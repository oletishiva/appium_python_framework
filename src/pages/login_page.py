from src.pages.base_page import BasePage
from appium.webdriver.common.appiumby import AppiumBy

from selenium.webdriver.common.by import By

from appium.webdriver.common.appiumby import AppiumBy

class LoginPage(BasePage):
    USERNAME_FIELD = (AppiumBy.ID, "com.gowithsparklearn.sparklearn.canary:id/setServer")
    PASSWORD_FIELD = (AppiumBy.ID, "com.gowithsparklearn.sparklearn.canary:id/password_field")
    LOGIN_BUTTON = (AppiumBy.ID, "com.gowithsparklearn.sparklearn.canary:id/setServerButton")
    GET_STARTED_BUTTON = (AppiumBy.ID, "com.gowithsparklearn.sparklearn.canary:id/getStarted")


    # Methods
    def enter_username(self, username):
        self.send_keys(self.USERNAME_FIELD, username)

    def enter_password(self, password):
        self.send_keys(self.PASSWORD_FIELD, password)

    def click_login(self):
        self.click(self.LOGIN_BUTTON)

    def click_get_started(self):
        self.click(self.GET_STARTED_BUTTON)
