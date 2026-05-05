# install.packages(c("flexmix", "ClustOfVar", "FactoMineR", "factoextra","pls","dplyr"))

# Charger les packages 
library(flexmix)
library(ClustOfVar)
library(FactoMineR)
library(factoextra)
library(pls)
library(dplyr)

# Charger les données
data <- read.csv("Datagenus.csv", sep = "\t", dec = ",", header = TRUE)

# Suppression variables qualitatives
data$forest <- NULL
data$geology <- NULL

# Séparation X et Y
Y <- data[, 1:27]                 # variables biologiques
X <- data[, -(1:27)]              # variables explicatives

# On garde seulement les variables numériques
X_quanti <- X[, sapply(X, is.numeric)]

# ACP
res.pca <- PCA(X_quanti, scale.unit = TRUE, graph = FALSE)

# Scree plot
fviz_eig(res.pca, addlabels = TRUE)

# Cercle des corrélations
fviz_pca_var(res.pca)

# Projection des individus
fviz_pca_ind(res.pca)

# Modèle linéaire 
for (col in colnames(Y)) {
  mod <- lm(Y[[col]] ~ ., data = X_quanti)
  cat("\n===== Modèle pour", col, "=====\n")
  print(summary(mod))
}

# PLS multivariée
Y_mat <- as.matrix(Y)
X_mat <- as.matrix(X_quanti)

res_pls <- plsr(
  Y_mat ~ X_mat,
  ncomp = 2,
  scale = TRUE,
  validation = "CV"
)

summary(res_pls)

# Graphique RMSEP
validationplot(res_pls, val.type = "RMSEP")

# Scores individuels
scores_pls <- scores(res_pls)

plot(scores_pls[,1], scores_pls[,2],
     xlab = "Comp 1", ylab = "Comp 2",
     main = "PLS - individus")

# Réduction de Y (PCA sur Y)
pca_Y <- prcomp(Y, scale = TRUE)

summary(pca_Y)   

# Première composante
data$Y1 <- pca_Y$x[,1]

# Modèle de mélange (FLEXMIX) : dataset propre 
data_mix <- data.frame(Y1 = data$Y1, X_quanti)

set.seed(123)

mod1 <- flexmix(Y1 ~ ., data = data_mix, k = 1)
mod2 <- flexmix(Y1 ~ ., data = data_mix, k = 2)
mod3 <- flexmix(Y1 ~ ., data = data_mix, k = 3)

# Comparaison BIC
bic_vals <- BIC(mod1, mod2, mod3)
print(bic_vals)

# Comparaison AIC
AIC(mod1, mod2, mod3)

# Comparaison des log‑vraisemblances 
logLik(mod1)
logLik(mod2)
logLik(mod3)

# Choix du meilleur modèle 
best_mod <- mod2

summary(best_mod)

# clusters
clusters <- clusters(best_mod)
table(clusters)

data_mix$cluster <- clusters

# interprétation des clusters
# Moyennes des variables biologiques
aggregate(Y, by = list(cluster = clusters), mean)

# Moyennes des variables explicatives
aggregate(X_quanti, by = list(cluster = clusters), mean)

# Clustering des variables 
tree <- hclustvar(X_quanti)
plot(tree)

# Partition en groupes
part <- cutreevar(tree, k = 3)
summary(part)
