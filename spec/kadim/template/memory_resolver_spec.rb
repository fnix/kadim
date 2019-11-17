# frozen_string_literal: true

require "rails_helper"
require "kadim/template/memory_resolver"

describe Kadim::MemoryResolver do
  subject(:resolver) { described_class.instance }

  let(:details) { { formats: [:html], locale: [:en], handlers: [:erb] } }

  describe "#find_all" do
    context "without a template match" do
      it "returns empty" do
        templates = resolver.find_all("index", "posts", false, details)
        expect(templates).to be_empty
      end
    end

    context "with a template match" do
      subject(:template) { resolver.find_all("index", "posts", false, details).first }

      before { resolver.add("<%= 'Hi from Kadim::MemoryResolver!' %>", "posts/index") }

      it "returns an ActionView::Template" do
        expect(template).to be_a(ActionView::Template)
      end

      it { expect(template.source).to eq("<%= 'Hi from Kadim::MemoryResolver!' %>") }
      it { expect(template.handler).to be_a(ActionView::Template::Handlers::ERB) }
      it { expect(template.format).to eq(:html) }
      it { expect(template.virtual_path).to eq("posts/index") }
      it { expect(template.identifier).to eq("posts/index.html.erb (kadim memory resolver)") }
    end
  end
end
