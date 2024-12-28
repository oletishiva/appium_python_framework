from appium.options.android import UiAutomator2Options
from appium import webdriver
from os import path

# Get the directory of the current script and construct the path to the APK
CUR_DIR = path.dirname(path.abspath(__file__))
APP = path.join(CUR_DIR, 'test.apk')

# Appium server URL
APPIUM = 'http://localhost:4723'  # Use /wd/hub only if running Appium 1.x

# Use UiAutomator2Options for cleaner capabilities
options = UiAutomator2Options()
options.platform_name = 'Android'
options.platform_version = '11'  # Match the version of your emulator/device
options.device_name = 'emulator-5554'
options.automation_name = 'UiAutomator2'
options.app = APP

# Initialize WebDriver
driver = webdriver.Remote(command_executor=APPIUM, options=options)

# Perform actions (e.g., launch app)
print("App launched successfully!")

# Close Driver
driver.quit()
