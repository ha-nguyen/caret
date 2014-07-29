modelInfo <- list(label = "Stacked AutoEncoder Deep Neural Network",
                  library = "deepnet",
                  loop = NULL,
                  type = c("Classification", "Regression"),
                  parameters = data.frame(parameter = c("layer1", "layer2", "layer3", "hidden_dropout", "visible_dropout"),
                                          class = rep("numeric", 5),
                                          label = c("Hidden Layer 1", "Hidden Layer 2", "Hidden Layer 3", 
                                                    "Hidden Dropouts", "Visible Dropout")),
                  grid = function(x, y, len = NULL) {
                    expand.grid(layer1 = 1:len, layer2 = 0:(len -1), layer3 = 0:(len -1),
                                hidden_dropout = 0, visible_dropout = 0)
                  },
                  fit = function(x, y, wts, param, lev, last, classProbs, ...) {
                    if(!is.matrix(x)) x <- as.matrix(x)
                    is_class <- is.factor(y)
                    ## make y into binary
                    layers <- c(param$layer1, param$layer2, param$layer3)
                    layers <- layers[layers > 0]
                    sae.dnn.train(x, y, hidden = layers, 
                                  output = if(is_class) "sigm" else "linear",
                                  hidden_dropout = param$hidden_dropout,
                                  visible_dropout = param$visible_dropout,
                                  ...)
                  },
                  predict = function(modelFit, newdata, submodels = NULL) 
                    nn.predict(modelFit, as.matrix(newdata))[,1],
                  prob = function(modelFit, newdata, submodels = NULL)
                    NULL,
                  predictors = function(x, ...) {
                    NULL
                  },
                  varImp = NULL,
                  levels = function(x) x$classes,
                  tags = c("Random Forest", "Ensemble Model", "Bagging", "Implicit Feature Selection"),
                  sort = function(x) x[order(x[,1]),])