Types of Tests:
1.Unit-testing a specific part of code
2.Integration-testing how our code works with other parts of our code.
3.Forked-Testing our code on a simulated real enviornment
4.Staging-when we deploy our code in a real enviornment that is not prod




forge coverage -- to check how many lines of code are tested


some tests need to make a call to a contract that exist---create and deploy mock contract(on anvil) and interact locally