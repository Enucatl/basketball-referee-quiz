basketball-ref-challenge.com
----------------------------

## ruby version
tested with 2.2.1

## System dependencies
puppet recipe included in [rails-do.pp](lib/puppet/rails-do.pp)

## create a digitalocean droplet
After creating a `config/secrets.yml` file containing the
`development.digitalocean_token` access token for the api, you can use the
capistrano tasks
```bash
cap staging digitalocean:create_droplet    # create a droplet through the API
cap staging digitalocean:destroy_droplet   # destroy the droplet through the API
```
    
## Database initialization
`cap production setup`

## Database seed
See the
[basketball-referee-generator](https://github.com/Enucatl/basketball-referee-generator)
project to change the seed questions. Then `cap production db:seed`. `rake
db:seed ../basketball-referee-generator/*.json` is what I use for local
                                         tests.

## Deployment instructions
`cap production deploy`
