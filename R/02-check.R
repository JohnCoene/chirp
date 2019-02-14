#' Check
#' 
#' Check configuration file, \code{_chirp.yml}.
#' 
#' @export
check_nest <- function(){

	file <- "_chirp.yml"

	if(!file.exists(file)){
		cat(
			crayon::red(cli::symbol$cross), "No", file, "in working directory\n"
		)
		return(NULL)
	}

	config <- yaml::read_yaml(file)

  if(length(config$credentials) == 0 || length(unlist(config$credentials)) == 0){

    rtweet_token <- tryCatch(rtweet::get_token(), error = function(e) NULL)

    if(!is.null(rtweet_token)){
      cat(
        crayon::yellow(cli::symbol$warning), "No credentials in", file, 
        ". Using stored credentials found on machine.\n"
      )
    } else {
      cat(
        crayon::red(cli::symbol$cross), "No credentials in", file, "\n"
      )
      return(NULL)  
    }

  } else {
		rtweet_token <- tryCatch(
			rtweet::create_token(
				app = "chirp",
				consumer_key = config$credentials$consumer_key,
				consumer_secret = config$credentials$consumer_secret,
				access_token = config$credentials$access_token,
				access_secret = config$credentials$access_secret
			),
			error = function(e) e
		)

		if(inherits(rtweet_token, "error")){
			cat(
				crayon::red(cli::symbol$cross), "Invalid credentials in", file, "\n"
			)
			return(NULL)
		}
	}

	cat(
		crayon::green(cli::symbol$tick), file, "looks valid", "\n"
	)

}