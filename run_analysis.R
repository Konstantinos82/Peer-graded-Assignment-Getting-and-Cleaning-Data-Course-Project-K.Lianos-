## 1. Download dataset / create folder to store it

data_url <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"

if(!file.exists("./UCI_dataset")){
  dir.create("./UCI_dataset")
}

download.file(data_url, destfile = "./UCI_dataset/smart_dataset.zip",
              method = "curl")