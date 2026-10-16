## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE---------------------------------------------------
library(networkformat)

## ----tree-edges, eval = requireNamespace("tree", quietly = TRUE)--------------
tr <- tree::tree(Species ~ Sepal.Length + Sepal.Width, data = iris)
edges <- edgelist(tr)
edges

## ----tree-filter, eval = requireNamespace("tree", quietly = TRUE)-------------
# All edges that split on Sepal.Length
edges[edges$split_var == "Sepal.Length", ]

# Thresholds above 5
edges[!is.na(edges$split_point) & edges$split_point > 5, ]

## ----tree-nodes, eval = requireNamespace("tree", quietly = TRUE)--------------
nodes <- nodelist(tr)
nodes

## ----tree-igraph, eval = requireNamespace("tree", quietly = TRUE) && requireNamespace("igraph", quietly = TRUE)----
library(igraph)
g <- graph_from_data_frame(edges, directed = TRUE, vertices = nodes)
cat("Nodes:", vcount(g), " Edges:", ecount(g), "\n")

## ----rf-edges, eval = requireNamespace("randomForest", quietly = TRUE), message = FALSE----
rf <- randomForest::randomForest(Species ~ ., data = iris, ntree = 3, maxnodes = 5)

# All trees
rf_edges <- edgelist(rf)
head(rf_edges)

## ----rf-treenum, eval = requireNamespace("randomForest", quietly = TRUE)------
# Single tree
t1 <- edgelist(rf, treenum = 1)
nrow(t1)

# Trees 1 and 3
t13 <- edgelist(rf, treenum = c(1, 3))
table(t13$treenum)

## ----rf-nodes, eval = requireNamespace("randomForest", quietly = TRUE)--------
rf_nodes <- nodelist(rf, treenum = 1)
rf_nodes

## ----df-basic-----------------------------------------------------------------
courses

edgelist(courses, source_cols = course, target_cols = prereq)

## ----df-multi-----------------------------------------------------------------
edgelist(courses, source_cols = course,
         target_cols = c(prereq, prereq2, crosslist))

## ----df-narm------------------------------------------------------------------
# Default: NAs removed
nrow(edgelist(courses, source_cols = course,
              target_cols = c(prereq, prereq2, crosslist)))

# Keep NAs
nrow(edgelist(courses, source_cols = course,
              target_cols = c(prereq, prereq2, crosslist),
              na.rm = FALSE))

## ----df-attrs-----------------------------------------------------------------
# Only from, to, metadata
edgelist(courses, source_cols = course, target_cols = prereq,
         attr_cols = c())

# Specific columns
edgelist(courses, source_cols = course, target_cols = prereq,
         attr_cols = c(dept, credits))

## ----df-sym-------------------------------------------------------------------
edgelist(courses, source_cols = course,
         target_cols = c(prereq, prereq2, crosslist),
         attr_cols = c(),
         symmetric_cols = crosslist)

## ----df-nodelist--------------------------------------------------------------
nodelist(courses, id_col = course)

## ----tidygraph-note, eval = FALSE---------------------------------------------
# edges <- edgelist(courses, source_cols = course, target_cols = prereq)
# tg <- tidygraph::as_tbl_graph(edges)

## ----courses-graph, eval = requireNamespace("igraph", quietly = TRUE), message = FALSE----
library(igraph)

all_edges <- edgelist(courses, source_cols = course,
                      target_cols = c(prereq, prereq2, crosslist),
                      attr_cols = c(),
                      symmetric_cols = crosslist)

# Reverse prereq arrows so they point from prereq -> dependent course
directed_rows <- all_edges$directed
all_edges[directed_rows, c("from", "to")] <- all_edges[directed_rows, c("to", "from")]

nodes <- nodelist(courses, id_col = course)
g <- graph_from_data_frame(all_edges, vertices = nodes)

## ----courses-stats, eval = requireNamespace("igraph", quietly = TRUE)---------
cat("Nodes:", vcount(g), "\n")
cat("Edges:", ecount(g), "\n")
cat("Components:", count_components(g), "\n")

# In-degree: how many prerequisites each course has
deg_in <- degree(g, mode = "in")
cat("\nMost prerequisites:\n")
print(sort(deg_in[deg_in > 0], decreasing = TRUE))

# Out-degree: how many courses depend on this one
deg_out <- degree(g, mode = "out")
cat("\nMost depended-on:\n")
print(sort(deg_out[deg_out > 0], decreasing = TRUE))

## ----list-edges---------------------------------------------------------------
edgelist(list(a = list(b = 1, c = 2), d = 3))

## ----list-unnamed-------------------------------------------------------------
edgelist(list(1, 2, list(3, 4)))

## ----list-maxdepth------------------------------------------------------------
edgelist(list(a = list(b = list(c = 1))), max_depth = 2)

## ----list-nodes---------------------------------------------------------------
nodelist(list(a = list(b = 1, c = 2), d = 3))

## ----list-s3, eval = FALSE----------------------------------------------------
# fit <- lm(Sepal.Length ~ Sepal.Width, data = iris)
# edgelist(fit)
# #> No edgelist method for class 'lm'; treating as a plain list.

