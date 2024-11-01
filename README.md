# 2024 US Election Prediction

## Overview

This repo include the code and paper to analyzes polling data from the 2024 U.S. presidential election that estimate the likely winner and understand the factors influencing the candidates’ support. Using simple and multiple linear regression models, we examine the impact of variables such as sample size, poll scores, and transparency on support percentage. The analysis showed that while the effect of sample size was limited, highly transparent polls were associated with an increase in candidate support, highlighting the impact of poll quality on public perception. Based on our model, because of the continued upward trend in support, we expect Donald Trump to be the likely front-runner. This paper also highlights the potential and limitations of statistical modeling in election prediction, enhancing our understanding of how voting methods shape public opinion in high-stakes elections.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from the US election website given.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models for candidates. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

In this project, I utilized Large Language Models (LLMs) for specific tasks related to data cleaning and visualization, such as aiding in the generation of R code for graphing and data manipulation. Additionally, LLMs were consulted to provide guidance on citation formatting in R, specifically for creating .bib entries.
