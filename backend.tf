terraform {
  backend "gcs" {
    bucket = "tf-state-lab3-makovska-tetiana-09"
    prefix = "env/dev/var-09.tfstate"
  }
}
