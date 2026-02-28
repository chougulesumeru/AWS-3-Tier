locals {
    name_prefix= "${project_name}-${environment}"

    tags ={
        name= "${project_name}-main"
    }

    depends_on= [aws_internate_gateway.igw]
}

