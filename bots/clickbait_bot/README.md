# tavern-bots - gpu bot

[![build-status](https://github.com/hwilloug/tavern-bots/actions/workflows/terraform.yml/badge.svg)](https://github.com/hwilloug/tavern-bots/actions/workflows/terraform.yml)

## local setup

the following things need to be installed on your computer for ease of development

- python3
- poetry


Create an `.env` file that contains: 

- `MASTODON_EMAIL` - email of bot account
- `MASTODON_PASSWORD` - password of bot account
- `MASTODON_CLIENT_ID` - mastodon client id
- `MASTODON_CLIENT_SECRET` - mastodon client secret


To run the bot, simply execute:

```
./bin/run.sh
```
