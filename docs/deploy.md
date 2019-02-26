---
id: deploy
title: Deploy
sidebar_label: Deploy
---

## Introduction

There are two main places to deploy Chirp:

1. On [shinyapps.io](https://www.shinyapps.io/)
2. On your own server

Whichever deployment method you want to choose, you will need a file named `app.R` that contains the functions which launches the Chirp: `chirp::chirp()`. There is a convenience function to obtain the latter.

```r
chirp::fly()
```

This will create a file named `app.R` in the working directory.

**⚠️Important**

If you had not specified your `credentials` in `_chirp.yml` you should either do so or get a token with [rtweet](https://rtweet.info/) from your server. This won't work on [shinyapps.io](https://www.shinyapps.io/), if you deploy on the latter you _have to_ add your `credentials` to the config file. 

## Shinyapps.io

Deploying on [shinyapps.io](https://www.shinyapps.io/) is probably the easiest solution. This requires the [RStudio IDE](https://www.rstudio.com/products/rstudio/), which is available for free and runs on any platform (Linux, Mac, and Windows).

 Note that there is a [thorough guide](https://shiny.rstudio.com/articles/shinyapps.html) if the explanation below does not suffice.

1. Open your Chirp project in RStudio.
2. Create an account on [shinyapps.io](https://www.shinyapps.io/).
3. Install `rsconnect` with `install.packages('rsconnect')`.
4. Load `rsconnect` with `library(rsconnect)`.
5. Go to your shinyapps dashboard, click your username and then click "Tokens".
6. Click the "Show" button and copy the command.
7. Paste and run the command from your project.
8. You can then deploy your application with `deployApp()`

You should then be able to see your application live at `https://myname.shinyapps.io/my-app/`

## Server


You can setup a [Shiny server](https://www.rstudio.com/products/shiny/shiny-server/) on pretty much any machine, you can download the [Community Edition](https://www.rstudio.com/products/shiny/download-server/) for free.

The best place to set this up is probably Digital Ocean which offers a [great guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-shiny-server-on-ubuntu-16-04) in case the instructions below do not suffice.

On a Digital Ocean Ubuntu 16.04 machine, first install R.

```bash
sudo apt-get install r-base
```

Then install the `shiny` and `remotes` package:

```bash
sudo su - -c "R -e \"install.packages(c('shiny', 'remotes'), repos='https://cran.rstudio.com/')\""
```

Note that all packages should be installed as above so that all users (including shiny) have access to the packages.

Now install Chirp.

```bash
sudo su - -c "R -e \"remotes::install_github('JohnCoene/chirp')\""
```

Now you can install the Shiny server.

```bash
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
sudo gdebi shiny-server-1.5.9.923-amd64.deb
```

By default the shiny server runs on port `3838`, make sure it is accessible with:

```bash
sudo ufw allow 3838
```

_You can change the port to `80` in the Shiny configuration file._

Your project folder which contains, at least, `app.R` and `_chirp.yml`, must be copied under `srv/shiny-server/`, you can do so however you prefer, i.e.: using Git. You can then visit your application at `domain.com/my-directory` .

Note that some options such as the `theme` require the server to be restarted in order to take effect; you can do so with.

```bash
sudo systemctl restart shiny-server
```

## Need help?

If you have a question or issue feel free to raise it on [Github](https://github.com/JohnCoene/chirp/issues). In case you're unsure how to deploy, I'll happily deploy it for you or your orgnisation in exchange for a ☕: hit the button below and contact me at _jcoenep@gmail.com_.

<style>.bmc-button img{width: 27px !important;margin-bottom: 1px !important;box-shadow: none !important;border: none !important;vertical-align: middle !important;}.bmc-button{line-height: 36px !important;height:37px !important;text-decoration: none !important;display:inline-flex !important;color:#000000 !important;background-color:#FFFFFF !important;border-radius: 3px !important;border: 1px solid transparent !important;padding: 0px 9px !important;font-size: 17px !important;letter-spacing:-0.08px !important;box-shadow: 0px 1px 2px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;margin: 0 auto !important;font-family:'Lato', sans-serif !important;-webkit-box-sizing: border-box !important;box-sizing: border-box !important;-o-transition: 0.3s all linear !important;-webkit-transition: 0.3s all linear !important;-moz-transition: 0.3s all linear !important;-ms-transition: 0.3s all linear !important;transition: 0.3s all linear !important;}.bmc-button:hover, .bmc-button:active, .bmc-button:focus {-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;text-decoration: none !important;box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;opacity: 0.85 !important;color:#000000 !important;}</style><link href="https://fonts.googleapis.com/css?family=Lato&subset=latin,latin-ext" rel="stylesheet"><a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/JohnCoene"><img src="https://www.buymeacoffee.com/assets/img/BMC-btn-logo.svg" alt="Buy me a coffee"><span style="margin-left:5px">Buy me a coffee</span></a>
