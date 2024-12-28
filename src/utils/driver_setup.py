from appium import webdriver

class DriverSetup:
    @staticmethod
    def get_driver():
        desired_caps = {
  "platformName": "Android",
  "appium:platformVersion": "11",
  "appium:deviceName": "emulator-5554",
  "appium:automationName": "UiAutomator2",
  "appium:app": "/Users/shivaoleti/Downloads/test.apk",
  "appium:appPackage": "com.gowithsparklearn.sparklearn.canary",
  "appium:appActivity": ".MainActivity",
  "appium:noReset": "true",
  "appium:fullReset": "false"
}
        # Initialize and return the driver
        driver = webdriver.Remote("http://localhost:4723/wd/hub", desired_caps)
        return driver
