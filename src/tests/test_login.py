import pytest
from src.utils.driver_setup import DriverSetup
from src.pages.login_page import LoginPage

class TestLogin:
    @pytest.fixture(scope="class")
    def setup(self):
        """
        Fixture to set up the driver and initialize the LoginPage object.
        The driver quits automatically after the test class finishes.
        """
        self.driver = DriverSetup.get_driver()
        self.login_page = LoginPage(self.driver)
        yield
        self.driver.quit()

    def test_valid_login(self, setup):
        """
        Test a valid login scenario.
        """
        # Perform actions using the LoginPage methods
        self.login_page.click_get_started()
        self.login_page.enter_username("testuser")
        self.login_page.click_login()

        # Add assertion to verify successful login
        # Example: Check if the dashboard is displayed (replace with actual locator)
        assert self.login_page.is_dashboard_displayed(), "Dashboard not displayed after login!"
