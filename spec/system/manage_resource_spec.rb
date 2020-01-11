# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage resources", type: :system do
  before { Kadim.bootstrap_controllers }

  context "when using kadim" do
    [nil, :bulma].each do |layout|
      context "using the #{layout} layout" do
        before do
          Kadim.layout = layout
        end

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

        context "without upload configuration" do
          before { Kadim.upload_type = nil }

          it "upload files to local storage" do
            visit "/kadim/users"
            click_link "New User"

            video_field = find_field("user[video]", type: "file")
            photos_field = find_field("user[photos][]", type: "file", multiple: true)

            expect(video_field["data-direct-upload-url"]).to be_nil
            expect(video_field["data-resumable-upload-url"]).to be_nil

            expect(photos_field["data-direct-upload-url"]).to be_nil
            expect(photos_field["data-resumable-upload-url"]).to be_nil
          end
        end

        context "with direct upload configured" do
          before { Kadim.upload_type = :direct }

          it "upload files direct to the cloud" do
            visit "/kadim/users"
            click_link "New User"

            video_field = find_field("user[video]", type: "file")
            photos_field = find_field("user[photos][]", type: "file", multiple: true)

            expect(video_field["data-direct-upload-url"]).to be_url
            expect(video_field["data-resumable-upload-url"]).to be_nil

            expect(photos_field["data-direct-upload-url"]).to be_url
            expect(photos_field["data-resumable-upload-url"]).to be_nil
          end
        end

        context "with resumable upload configured" do
          before { Kadim.upload_type = :resumable }

          it "upload files direct to the cloud with resumable support" do
            visit "/kadim/users"
            click_link "New User"

            video_field = find_field("user[video]", type: "file")
            photos_field = find_field("user[photos][]", type: "file", multiple: true)

            expect(video_field["data-direct-upload-url"]).to be_nil
            expect(video_field["data-resumable-upload-url"]).to be_url

            expect(photos_field["data-direct-upload-url"]).to be_nil
            expect(photos_field["data-resumable-upload-url"]).to be_url
          end
        end
      end
    end
  end
end
