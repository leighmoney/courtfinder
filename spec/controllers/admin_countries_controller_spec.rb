require 'spec_helper'

describe Admin::CountriesController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = Country.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, country: {}
    response.should redirect_to(edit_admin_country_path(object))
  end

  it "purges the cache when a new object is created" do 
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, country: {}
      response.should redirect_to(edit_admin_country_path(assigns(:country)))
    }.to change { Country.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = Country.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_countries_path)
    }.to change { Country.count }.by(-1)
  end
end
