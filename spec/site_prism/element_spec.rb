# frozen_string_literal: true

describe SitePrism do
  describe 'Element' do
    # This stops the stdout process leaking between tests
    before { wipe_logger! }

    let(:expected_elements) { SitePrism::SpecHelper.present_on_page }

    shared_examples 'an element' do
      describe '.element' do
        it 'can be set on `SitePrism::Page`' do
          expect(SitePrism::Page).to respond_to(:element)
        end

        it 'can be set on `SitePrism::Section`' do
          expect(SitePrism::Section).to respond_to(:element)
        end
      end

      it { is_expected.to respond_to(:element_one) }
      it { is_expected.to respond_to(:has_element_one?) }
      it { is_expected.to respond_to(:has_no_element_one?) }
      it { is_expected.to respond_to(:wait_until_element_one_visible) }
      it { is_expected.to respond_to(:wait_until_element_one_invisible) }

      it 'supports rspec existence matchers' do
        expect(subject).to have_element_one
      end

      it 'supports negated rspec existence matchers' do
        expect(subject).to receive(:has_no_element_two?).once.and_call_original
        expect(subject).not_to have_element_two
      end

      describe '#elements_present' do
        it 'only lists the SitePrism objects that are present on the page' do
          expect(page.elements_present.sort).to eq(expected_elements.sort)
        end
      end

      describe '.expected_elements' do
        it 'sets the value of expected_items' do
          expect(klass.expected_items)
            .to eq(%i[element_one elements_one section_one sections_one])
        end
      end
    end

    context 'with a Page defined using CSS locators' do
      subject { page }

      let(:page) { CSSPage.new }
      let(:klass) { CSSPage }

      it_behaves_like 'an element'
    end

    context 'with a Page defined using XPath locators' do
      subject { page }

      let(:page) { XPathPage.new }
      let(:klass) { XPathPage }

      it_behaves_like 'an element'
    end
  end
end
