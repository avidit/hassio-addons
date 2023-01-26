#!/usr/bin/env bashio

MQTT_HOST="$(bashio::config 'mqtt_host')"
MQTT_PORT="$(bashio::config 'mqtt_port')"
MQTT_USER="$(bashio::config 'mqtt_user')"
MQTT_PASS="$(bashio::config 'mqtt_pass')"
MSG_TYPES="$(bashio::config 'msg_types')"
METER_IDS="$(bashio::config 'meter_ids')"
SLEEP="$(bashio::config 'sleep')"

bashio::log.info "Starting rtlamr2mqtt..."
bashio::log.info "MQTT host: $MQTT_HOST"
bashio::log.info "MQTT port: $MQTT_PORT"
bashio::log.info "MQTT username: $MQTT_USER"
bashio::log.info "MQTT password: $MQTT_PASS"
bashio::log.info "Message Types: $MSG_TYPES"
bashio::log.info "Meter IDs: $METER_IDS"
bashio::log.info "SLEEP: $SLEEP"

while true; do
    bashio::log.info "Starting rtl_tcp..."
    rtl_tcp >/dev/null 2>&1 &
    sleep 10s

    bashio::log.info "Starting rtlamr..."
    rtlamr -format=json -single=true -msgtype="$MSG_TYPES" -filterid="$METER_IDS" | while read -r line; do
        bashio::log.info "$line"
        TYPE=$(echo "$line" | jq -r '.Type')
        METER_ID=$(echo "$line" | jq -r '.Message.ID')
        if [ "$TYPE" = "SCM" ] || [ "$TYPE" = "R900" ] || [ "$TYPE" = "R900BCD" ]; then
            METER_ID=$(echo "$line" | jq -r '.Message.ID')
        elif [ "$TYPE" = "SCM+" ]; then
            METER_ID=$(echo "$line" | jq -r '.Message.EndpointID')
        elif [ "$TYPE" = "IDM" ] || [ "$TYPE" = "NetIDM" ]; then
            METER_ID=$(echo "$line" | jq -r '.Message.ERTSerialNumber')
        else
            METER_ID='unknown'
        fi
        MQTT_TOPIC="meter/$METER_ID/reading"
        mkdir -p /config/rtlamr2mqtt
        echo "$line" >>/config/rtlamr2mqtt/"$METER_ID".ndjson
        bashio::log.info "Publishing to mqtt topic $MQTT_TOPIC: $line"
        mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_TOPIC" -m "$line" -i rtlamr2mqtt -r
    done
    bashio::log.info "Stopping rtl_tcp..."
    pkill rtl_tcp
    bashio::log.info "Sleeping for $SLEEP"
    sleep "$SLEEP"
done
