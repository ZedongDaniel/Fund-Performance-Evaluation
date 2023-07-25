# Fund-Performance-Evaluation
This Project is an assignment in FINA 5422(Financial Econometrics and Computational Methods I) at the Carlson School of Management, University of Minnesota.    

In the script, I investigated and compared several mutual funds' performances in the last ten years. I picked six JP Morgan and Black Rock fund and separated them into three categories (US Large Cap, US Small Cap, US vs China). 
- JP Morgan U.S. Research Enhanced Equity Fund (Large Cap Fund with growth potential)  
- JP Morgan Small Cap Equity Fund (small Cap Fund)  
- JP Morgan Equity Income Fund (low volatility with respect to the Market)  
- Black Rock SP-500 Growth ETF fund (Large Cap Fund with growth potential)  
- Black Rock Russell 2000 ETF fund (small Cap fund)  
- Black Rock MSCI China-ETF fund (Investing in Chinese Stock Market)

By cumulating each fund’s monthly return, I found out the return by holding funds for one year. From the graph, it is clear that in Large Cap and Small Cap sectors, JP Morgan and BlackRock's fund performance is similar. In the Large Cap sector, Black Rock's SP-500 Growth ETF fund generates more return for investors. However, By comparing investing in US or China, we can clearly tell investing US fund is much better.
![](https://github.com/ZedongDaniel/Fund-Performance-Evaluation/blob/3f9c14ba6ed7e29f982116c5e6181dd50925de17/images/holding%201%20year.jpg)  

Then, I ran a Monte Carlo simulation to simulate investing one dollar into each fund for 60 months. BlackRock’s large-cap fund truly outperformed JPMorgan’s, and BlackRock’s small Cap Fund was the same as JPMogran’s. And holding US high dividend stock is better than holding Chinese stock ETF. From the last sub-figure, the BlackRock SP-500 Growth ETF fund outperformed all other five funds.
![](https://github.com/ZedongDaniel/Fund-Performance-Evaluation/blob/6680eba7d7c838dce6a2441081ea9c88b0f35b97/images/simulation.jpg)  
Then, I ran regression and calculated Fama French 3 Factor Alpha. The regression result is below:

|    name   | jpm_lcap | br_lcap | jpm_scap | br_scap | jpm_eqincome | br_china |
| -------   | -------- | ------- |--------  | ------- | -----------  |----------- |
| $\alpha$  | -0.0002  | 0.0006  | -0.0007  | -0.0015 |   0.0002     | -0.0017  |
| $beta$    | 1.0031   | 1.0388  | 0.9569   | 1.0056  |  0.8475      | 0.5586   |
| $s$       | -0.1074  | -0.1987| 0.4587    | 0.8481  | -0.1240      | 0.1845   | 
| $h$       | 0.0270   | -0.2648 | 0.1614   | 0.1824   | 0.2694      | -0.0006  |

From the regression output, the asset management firm does hold the class of stock as they claimed on their website (i.e., BlackRock Russell 2000 ETF fund does hold small stock in their portfolio). However, JPMorgan U.S. Research Enhanced Equity Fund(Jjm_lcap) said they hold stock in which the company has growth potential. But we saw that JPMorgan U.S. Research Enhanced Equity Fund actually holds value stocks(>0), and the t-stat shows h is truly greater than 0.  

From the table, the BlackRock SP-500 Growth ETF fund had a positive alpha. Thus, Let's examine further into this fund. I constructed the BlackRock SP-500 Growth ETF fund benchmark. In addition, I plotted to to return over time by the investment of 1 dollar and its excess return.

BlackRock SP-500 Growth ETF fund did perform better than the benchmark and market; it was one valuable fund that investors could consider investing in.






