# Garagemail

Triggers my.OpenHAB events from incoming mails from [Chamberlain MyQ](https://www.amazon.com/gp/product/B00EAD65UW/?tag=cc0a0-20) (which is a horrible device).

## Usage

### Setting up this app

1. Clone this repo and `cd` in
2. Create a new heroku app
3. Set env variables for your my.openHAB user/pass:
  - `heroku config:set HAB_USER=blah@blah.com`
  - `heroku config:set HAB_PASS=blah`
4. Pick a random URL:
  - `heroko config:set POST_URL=lotsofrandomletters`
5. Add the Postmark extension.
  - `heroku addons:add postmark:10k`
  - `heroku addons:open postmark`
  - Configure postmark with your heroku URL
6. Deploy the app `git push heroku master`

### Setting up Chamberlain

In their infinite corporate wisdom, Chamberlain doesn't allow to either use different emails for notifications, or even change your email, so you'll probably need to set up email forwarding to your new postmark email.

### Setting up OpenHAB

Currently my.openHAB doesn't work with updates (PUT requests), so you'll need to create a Switch Item called `itm_garage_door_notifier`, that has a rule to update the status of the actual garage door:

```java
rule "Garage door notifications"
when
  Item itm_garage_door_notifier received command
then
  if(receivedCommand==ON) {
    postUpdate(itm_garage_door, OPEN)
  } else {
    postUpdate(itm_garage_door, CLOSED)
  }
end
```

## Credits

- Author: [JustinAiken](https://github.com/JustinAiken)

### License

[MIT](LICENSE)
