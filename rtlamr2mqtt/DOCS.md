# About

The rtlamr2mqtt add-on allows you read utility meters
using rtl-sdr and rtlamr and send to homeassistant via MQTT

## Installation

The installation of this add-on is straightforward and easy to do.

1. Navigate in your Home Assistant frontend to **Hass.io** -> **Add-on Store**.
2. Add the Hass.io add-on repository `https://github.com/avidit/hassio-addons`.
3. Install the "rtlamr to MQTT" add-on.

## Configuration

Example add-on configuration:

```yaml
mqtt_host: "core-mosquitto",
mqtt_port: 1883,
mqtt_user: "mosquitto",
mqtt_pass: "mosquitto",
msg_types: "scm,r900",
meter_ids: "1234,5678"
sleep: 1h
```

## More info

- [rtl-sdr](https://osmocom.org/projects/rtl-sdr)
- [rtlamr](https://github.com/bemasher/rtlamr)
- [mqtt](https://mqtt.org/)
