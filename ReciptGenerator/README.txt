Steps for running solution:

1) Ensure files are all located in a directory named app

2) open cmd and set working directory to [directory with app package] with:
    cd [directory with app package]

3) run javac using the command:
    javac [directory with app package] -cp .. app.java
    (running unit tests is the same process with app.java replaced with the unit test file name)

4) set working directory to the directory containing the app package using:
    cd ..

5) run java using the command:
    java app.app
    (replace the second instance of app with the unit test if testing)
