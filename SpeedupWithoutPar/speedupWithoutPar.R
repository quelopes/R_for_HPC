#!/usr/bin/env Rscript

# === Benchmark de diversas estrategias de laco no R (Sem paralelismo) ===

pot = 5
# Create the data frame
col1 <- runif (12^pot, 0, 2)
col2 <- rnorm (12^pot, 0, 2)
col3 <- rpois (12^pot, 3)
col4 <- rchisq (12^pot, 2)
data <- data.frame (col1, col2, col3, col4)
rm(list=c("col1","col2","col3","col4"))
dim(data)

# === original ===
original = function(df){
  for (i in 1:nrow(df)) { # for every row
    if ((df[i, 'col1'] + df[i, 'col2'] + df[i, 'col3'] + df[i, 'col4']) > 4) { # check if > 4
      df[i, 5] <- "greater_than_4" # assign 5th column
    } else {
      df[i, 5] <- "lesser_than_4" # assign 5th column
    }
  }
}

# === pre-aloc ===
preAloc = function(df){
  output <- character (nrow(df)) # initialize output vector
  for (i in 1:nrow(df)) {
    if ((df[i, 'col1'] + df[i, 'col2'] + df[i, 'col3'] + df[i, 'col4']) > 4) {
      output[i] <- "greater_than_4"
    } else {
      output[i] <- "lesser_than_4"
    }
  }
  df$output
}  

# === outside loop ===
outloop = function(df){
  output <- character (nrow(df))
  condition <- (df$col1 + df$col2 + df$col3 + df$col4) > 4  # condition check outside the loop
  for (i in 1:nrow(df)) {
    if (condition[i]) {
      output[i] <- "greater_than_4"
    } else {
      output[i] <- "lesser_than_4"
    }
  }
  df$output <- output
}

# === one condition ===
oneCond = function(df){
  output <- character(nrow(df))
  condition <- (df$col1 + df$col2 + df$col3 + df$col4) > 4
  for (i in (1:nrow(df))[condition]) {  # run loop only for true conditions
    if (condition[i]) {
      output[i] <- "greater_than_4"
    } else {
      output[i] <- "lesser_than_4"
    }
  }
  df$output 
}

# === ifelse ===
ifElse = function(df){
  output <- ifelse ((df$col1 + df$col2 + df$col3 + df$col4) > 4, "greater_than_4", "lesser_than_4")
  df$output <- output
}

# === which ===
uiti = function(df){
  want = which(rowSums(df) > 4)
  output = rep("less than 4", times = nrow(df))
  output[want] = "greater than 4"
}


# === system.time ===
system.time({original(data)})
system.time({preAloc(data)})
system.time({outloop(data)})
system.time({oneCond(data)})
system.time({ifElse(data)})
system.time({uiti(data)})

