library("DALEX")
library("arenar")
library("ranger")
library("gbm")

# load data
happiness <- readRDS("happiness.rds")

# fit models
model_rf <- ranger(score~., data = happiness)
model_gbm <- gbm(score~., data = happiness)

# create explainers for the models
explainer_rf <- explain(model_rf,
                        data = happiness[,-1],
                        y = happiness$score)
explainer_gbm <- explain(model_gbm,
                         data = happiness[,-1],
                         y = happiness$score)

# choose observations to be explained
observations <- happiness[1:10, ]

# make an Arena for the models
library("dplyr", quietly=TRUE, warn.conflicts = FALSE)
arena <- create_arena(live=TRUE) %>%
  push_model(explainer_rf) %>%
  push_model(explainer_gbm) %>%
  push_observations(observations)

# explain!
run_server(arena)
