resource "aws_iam_service_linked_role" "imagebuilderRole" {
  aws_service_name = "imagebuilder.amazonaws.com"
}

resource "aws_iam_role" "imagebuilderProfileRole" {
  name                 = format("iam-role-%s-imagebuilderProfileRole", "app")
  assume_role_policy   = data.aws_iam_policy_document.imagebuilderEc2profilePolicy.json
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilder" {
  role       = aws_iam_role.imagebuilderProfileRole.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

data "aws_iam_policy_document" "imagebuilderEc2profilePolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_imagebuilder_image_recipe" "ImageBuilderRecipe" {

  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/amazon-cloudwatch-agent-linux/1.0.1/1"
  }

  name         = "ImageBuilderRecipe" 
  parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-arm64/2022.1.25"
  version      = "1.0.0"
}

resource "null_resource" "resource1" {
  count = 3
}
