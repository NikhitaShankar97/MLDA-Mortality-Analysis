# **Mortality and Minimum Legal Drinking Age (MLDA) Analysis**
### *A Statistical Study of Mortality Rates Around the Legal Drinking Age Threshold*

---

### **Project Overview**
This project investigates the impact of crossing the **Minimum Legal Drinking Age (MLDA)** on mortality rates, focusing on:
- Analyzing mortality rates (all causes and motor vehicle-related) before and after the MLDA cutoff.
- Visualizing trends in mortality rates relative to the MLDA threshold.
- Utilizing **Regression Discontinuity (RD)** methods to measure causal effects of the MLDA on mortality rates.

The study demonstrates the potential implications of the MLDA policy on public safety and provides actionable insights for policymakers.

---

### **Objective**
To evaluate the impact of the MLDA on:
- Overall mortality rates.
- Motor vehicle accident-related mortality rates.
- The effectiveness of the MLDA policy in reducing mortality risks.

---

### **Key Insights**
1. **Mortality Rate Differences**:
   - A noticeable jump in mortality rates is observed at the MLDA threshold.
   - Motor vehicle accident-related deaths significantly increase after crossing the MLDA.

2. **Regression Discontinuity Results**:
   - **Non-Parametric RD**: Shows localized effects of MLDA on mortality rates for various bandwidths.
   - **Parametric RD**: Incorporates broader trends and validates the policy's impact on mortality.

3. **Scatter Plot Visualization**:
   - Black points indicate overall mortality rates.
   - Blue points highlight motor vehicle accident mortality rates.
   - The red dashed line marks the MLDA threshold, showcasing a clear discontinuity.

---

### **Tools and Technologies**
- **Programming Language**: R
- **Libraries**: `ggplot2`, `dplyr`, `haven`
- **Statistical Methods**: Regression Discontinuity (RD), parametric and non-parametric analysis
- **Data Sources**: Mortality statistics from a public GitHub repository

---

### **How to Run**
#### **Run Locally in RStudio**
1. Download and install [RStudio](https://www.rstudio.com/).  
2. Clone this repository:
   ```bash
   git clone https://github.com/YourUsername/MLDA-Mortality-Analysis.git
3. Open MLD_Mortality_Analysis.R in RStudio.
4. Install the required packages if not already installed:
install.packages(c("haven", "ggplot2", "dplyr"))
5. Run the script to reproduce the analysis and generate visualizations.

---

### ***Strategic Recommendations**
### ***Policy Implications:***

- Stricter enforcement of the MLDA can potentially save lives, particularly from motor vehicle accidents.
Additional awareness campaigns around the risks of drinking and driving at the MLDA threshold.
Further Research:

- Evaluate the long-term impact of MLDA on mortality rates beyond 24 months.
Investigate other socioeconomic factors influencing mortality trends around the MLDA.

---
### **Contact**
- **Author**: Nikhita Shankar  
- **Email**: [nikhita4@illinois.edu](mailto:nikhita4@illinois.edu)  
- **LinkedIn**: [Nikhita Shankar](https://linkedin.com/in/nikhita-shankar-)  
