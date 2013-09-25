# encoding: utf-8

require 'spec_helper'

describe 'layouts/base' do
  describe 'title' do
    it 'should be specified title if specified.' do
      title = random_text length: 32
      view.content_for(:title) { title }
      render
      rendered.should have_selector 'title', content: "#{title} • #{$globals.application.titlecase}"
    end

    it 'should be application name if not specified.' do
      render
      rendered.should have_selector 'title', content: $globals.application.titlecase
    end
  end

  context 'when content is specified' do
    let(:content) { random_text length: 256 }

    it 'should be rendered as body.' do
      render inline: "<% content_for :content do %>#{content}<% end %>", layout: 'layouts/base'
      rendered.should have_selector 'body', content: content
    end

    it 'should not render anything else.' do
      other = random_text length: 256
      render inline: "<% content_for :content do %>#{content}<% end %>#{other}", layout: 'layouts/base'

      rendered.should_not contain other
    end
  end

  context 'when content is not specified' do
    it 'should render everything as body' do
      everything = random_text length: 256
      render inline: everything, layout: 'layouts/base'

      rendered.should have_selector 'body', content: everything
    end
  end
end