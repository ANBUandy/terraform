/* Setup our aws provider */
provider "aws" {
  region  = "${var.region}"
  profile = "dexion-${var.environment}"
}
