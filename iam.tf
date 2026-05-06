# Buscamos el rol que AWS Academy ya creó por nosotros
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}
