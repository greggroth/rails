require File.join(File.expand_path(File.dirname(__FILE__)), "test_helper")

module ControllerLayouts
  class ImplicitController < ::ApplicationController
    self.view_paths = [ActionView::Template::FixturePath.new(
      "layouts/application.html.erb" => "OMG <%= yield %> KTHXBAI",
      "layouts/override.html.erb"    => "Override! <%= yield %>",
      "basic.html.erb"               => "Hello world!",
      "controller_layouts/implicit/layout_false.html.erb" => "hai(layout_false.html.erb)"
    )]

    def index
      render :template => "basic"
    end

    def override
      render :template => "basic", :layout => "override"
    end

    def layout_false
      render :layout => false
    end

    def builder_override
    end
  end

  class ImplicitNameController < ::ApplicationController
    self.view_paths = [ActionView::Template::FixturePath.new(
      "layouts/controller_layouts/implicit_name.html.erb" => "OMGIMPLICIT <%= yield %> KTHXBAI",
      "basic.html.erb" => "Hello world!"
    )]

    def index
      render :template => "basic"
    end
  end

  class RenderLayoutTest < SimpleRouteCase
    test "rendering a normal template, but using the implicit layout" do
      get "/controller_layouts/implicit/index"

      assert_body   "OMG Hello world! KTHXBAI"
      assert_status 200
    end

    test "rendering a normal template, but using an implicit NAMED layout" do
      get "/controller_layouts/implicit_name/index"

      assert_body "OMGIMPLICIT Hello world! KTHXBAI"
      assert_status 200
    end

    test "overriding an implicit layout with render :layout option" do
      get "/controller_layouts/implicit/override"
      assert_body "Override! Hello world!"
    end

  end

  class LayoutOptionsTest < SimpleRouteCase
    testing ControllerLayouts::ImplicitController

    test "rendering with :layout => false leaves out the implicit layout" do
      get :layout_false
      assert_response "hai(layout_false.html.erb)"
    end
  end
end