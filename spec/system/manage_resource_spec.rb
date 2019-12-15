# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage resources", type: :system do
  before do
    Kadim.bootstrap_controllers
  end

  context "when using kadim" do
    it "can list resources" do
      ["Sherlock Holmes", "Dr. Watson"].each { |name| User.create name: name }

      visit "/kadim/users"

      expect(page).to have_content("Sherlock Holmes")
      expect(page).to have_content("Dr. Watson")
    end

    it "can create resources" do
      visit "/kadim/users"
      click_link "New User"
      click_button "Create User"

      expect(page).to have_content("User was successfully created.")
    end

    it "can edit resources" do
      User.create name: "Sherlock Holmes"

      visit "/kadim/users"
      click_link "Edit"
      fill_in "Name", with: "Xerox Holmes"
      click_button "Update User"

      expect(page).to have_content("User was successfully updated.")
      expect(page).to have_content("Xerox Holmes")
      expect(page).not_to have_content("Sherlock Holmes")
    end

    it "can destroy resources" do
      ["Sherlock Holmes", "Dr. Watson"].each { |name| User.create name: name }

      visit "/kadim/users"

      expect(page).to have_content("Sherlock Holmes")
      expect(page).to have_content("Dr. Watson")

      within(:xpath, "//table/tbody/tr[td[contains(text(),'Dr. Watson')]]") do
        click_link "Destroy"
      end

      expect(page).to have_content("User was successfully destroyed.")
      expect(page).not_to have_content("Dr. Watson")
    end
  end
end
