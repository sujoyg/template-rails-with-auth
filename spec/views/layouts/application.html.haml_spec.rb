require 'spec_helper'

describe 'layouts/application' do
  let(:content) { random_text length: 256 }

  it 'should act as a layout.' do
    render inline: content, layout: 'layouts/application'
    rendered.should contain content
  end

  it 'should renders a header.' do
    render inline: content, layout: 'layouts/application'
    view.should render_template partial: 'layouts/_header'
  end

  it 'should render the alert if present.' do
    flash[:alert] = alert = random_text length: 1024
    render inline: content, layout: 'layouts/application'
    rendered.should contain alert
  end
end