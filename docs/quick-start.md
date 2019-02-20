---
id: quick-start
title: Quick Start
sidebar_label: Quick Start
---

Check the [demo](https://shiny.john-coene/chirp) to see Chirp in action.

## Install

Chirp is written in [R](https://www.r-project.org/), the programming language must thus be installed on your machine. Once installed follow the instructions below to setup a working Chirp platform on your local machine.

First, create an empty directory where to host the Chirp.

```bash
mkdir chirp
cd ./chirp
```

Chirp is hosted on [Github](https://github.com/JohnCoene/chirp) and can be installed using the `remotes` package. The command below will install Chirp on your platform.

<!--DOCUSAURUS_CODE_TABS-->
<!--R-->
```r
install.packages("remotes", repos = "https://cran.rstudio.com")
remotes::install_github('JohnCoene/chirp')
```
<!--Terminal-->
```bash
R -e "install.packages('remotes', repos = 'https://cran.rstudio.com');\remotes::install_github('JohnCoene/chirp')"
```

<!--END_DOCUSAURUS_CODE_TABS-->

## Initialise

Now we can initialise Chirp. Then again make sure you are running the from _root of the directory_ where you want the application hosted. The command below will create a default configuration file called `_chirp.yml` in your working directory and open it in your terminal or [RStudio IDE](https://www.rstudio.com/products/rstudio/).

<!--DOCUSAURUS_CODE_TABS-->
<!--R-->
```r
chirp::build_nest()
```
<!--Terminal-->
```bash
R -e "chirp::build_nest()"
```

<!--END_DOCUSAURUS_CODE_TABS-->

## Configure

The configuration file (`_chirp.yml`) allows you to customise Chirp and hold your credentials. The credentials are somewhat particular, either:

1. You have already used the `rtweet` package in which case Chirp will use your internally saved credentials: you can thus jump straight to the [Check section](#check).
2. You have never use `rtweet` on your machine, in which case you simply follow along to get setup.

There is probably a third possibility, the above confuses you as you are not familiar with R or `rtweet`, in which case keep reading.

Chirp comes integrated with the [Twitter Search API](https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets.html), the credentials discussed above will enable Chirp to fetch tweets. Therefore, having either `credentials` specified in `_chirp.yml` or having an `rtweet` token saved internally. Note that this is the _only_ required option in Chirp.

You can obtain the keys and tokens mentioned in `_chirp.yml` under `credentials` by heading to [apps.twitter.com](https://apps.twitter.com) and creating an application. Fill in the form however you see fit, the only thing of importance is to fill in the "Callback URLs" with `http://127.0.0.1:1410`.

With that done head to the "Keys and tokens" tab where you should find the information required in `_chirp.yml`:

```yaml
credentials:                    
  consumer_key: xXxxXXxxxxXXxxX
  consumer_secret: xXxxXXxxxxXXxxX
  access_token: xXxxXXxxxxXXxxX
  access_secret: xXxxXXxxxxXXxxX
```

## Check

Before we launch Chirp we can make sure that Chirp can run. The function below will print helpful messages to the console in case there are issues.

<!--DOCUSAURUS_CODE_TABS-->
<!--R-->
```r
chirp::check_nest()
```
<!--Terminal-->
```bash
R -e "chirp::check_nest()"
```

<!--END_DOCUSAURUS_CODE_TABS-->

## Run

You can now run Chirp.

<!--DOCUSAURUS_CODE_TABS-->
<!--R-->
```r
chirp::chirp()
```
<!--Terminal-->
```bash
R -e "chirp::chirp()"
```

<!--END_DOCUSAURUS_CODE_TABS-->

## Recap

The above can be compacted into the snippet below.

```r
devtools::install_github("JohnCoene/chirp") # install
chirp::build_nest() # create config file
chirp::check_nest() # check config file
chirp::chirp() # launch
```

