## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----vector-quick-------------------------------------------------------------
library(networkformat)

edgelist(c("start", "middle", "end"))
nodelist(c("A", "B", "A", "C"))

## ----quick-example, eval = requireNamespace("tree", quietly = TRUE) && requireNamespace("ggraph", quietly = TRUE), fig.width = 9, fig.height = 6, message = FALSE----
library(networkformat)
library(tidygraph)
library(ggraph)

tr <- tree::tree(Species ~ Sepal.Length + Sepal.Width, data = iris)
tg <- as_tbl_graph(tr)

ggraph(tg, layout = "tree") +
  geom_edge_diagonal(colour = "grey60") +
  geom_node_label(aes(label = label, fill = ifelse(is_leaf, yval, var)),
                  size = 2.5, colour = "white", fontface = "bold") +
  scale_fill_brewer(palette = "Set2", name = NULL) +
  theme_graph(base_family = "sans") +
  labs(title = "Iris classification tree")

## ----df-quick-----------------------------------------------------------------
library(networkformat)

# Prerequisite edgelist
edgelist(courses, source_cols = course, target_cols = prereq)

# Node list with course as ID
nodelist(courses, id_col = course)

