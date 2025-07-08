# Cloud Resume Challenge 🌥️

This project is my take on the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) - an end-to-end cloud engineering project designed by Forrest Brazeal. It's a full-stack serverless web app deployed using AWS, featuring CI/CD automation, Infrastructure as Code, and API integration.
The outcome can be viewed at [jaylaba.com](https://jaylaba.com) and [here](https://dev.to/jarosaw_aba_75c095abd8e/the-cloud-resume-challenge-a-perfect-way-to-explore-the-cloud-5gk5) you can find my blog post describing the whole process in much more detail.

## 🚀 What It Does

- Hosts a resume website on a custom domain using **S3** + **CloudFront** + **HTTPS**  
- Tracks visitor count with a **DynamoDB** backend, exposed via a **Python AWS Lambda** + **API Gateway**  
- Uses **JavaScript** to fetch and display the count in real time  
- Includes **Cypress tests** for API functionality  
- Deploys infrastructure with **Terraform** and automates deployments via **GitHub Actions**

## 🧰 Technologies Used

- **Frontend**: HTML, Tailwind CSS, JavaScript
- **Backend**: AWS Lambda (Python), API Gateway, DynamoDB
- **DevOps**: Terraform, GitHub Actions
- **Other AWS Services**: S3, CloudFront, IAM, Certificate Manager, IAM Identity Center, AWS Organizations
- **DNS & CDN**: Cloudflare

## 🏗️ Project Architecture
The diagram below illustrates the application architecture and the data flow:
- The user sends an HTTP request from the browser.
- DNS and domain management are handled by Cloudflare.
- Static site assets are served by Amazon S3 and delivered globally via CloudFront with HTTPS.
- The visit counter functions as a REST API managed by Amazon API Gateway, which invokes an AWS Lambda function written in Python.
- The Lambda function performs operations on a DynamoDB table, saving and reading visit data.
- A JSON response is returned to the browser and displayed to the user.
  
![image](https://github.com/user-attachments/assets/5fb18db1-3f37-4264-85db-108883e21e96)
