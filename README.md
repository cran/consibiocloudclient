
<!-- We'll also generated the README.md from the .Rmd file-->

<img src="man/figures/logo.png" width="120" alt="Consibio Cloud" />

`consibiocloudclient` are used to fetch data from Consibio Cloud. You’ll
need to have a [Consibio Cloud](https://consibio.cloud/) account, in
other to use this client.

Our R client interacts with the [Consibio Cloud
API](https://api.v2.consibio.com/api-docs/), and provides tools to query
data from resources like projects, elements, devices, and datalogs.

If you find any bugs or have any suggestions, please submit a request at
our support portal.

## Installing

`consibiocloudclient` is available on CRAN, and can be installed with:

``` r
install.packages("consibiocloudclient")
```

## Getting started

To get started, you’ll need to authenticate with your Consibio Cloud
account. This is done by calling the `login` function, which takes your
username (email) as argument.

Once you execute the `login` function, a password prompt will appear,
and you’ll be asked to enter your password.

``` r
library(consibiocloudclient)

login("bob@helloworld.com")

# After a successful login, a token will be stored in memory.
projects <- get_projects()

# If you want to log out, you can call the `logout` function.
logout()

# After logging out, it's necessary to restart your R-session in other to remove any token stored in memory.
```

For a more in-depth guide on how to get started, please see
`vignette("consibiocloudclient")`. Open the vignette overview in your
browser with `browseVignettes("consibiocloudclient")`.
