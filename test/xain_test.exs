defmodule XainTest do
  use ExUnit.Case
  use Xain

  setup do 
    Application.put_env :xain, :after_callout, nil
    :ok
  end

  test "simple div" do
    result = markup do
      div
    end
    assert result == "<div></div>"
  end

  test "nesting div span" do
    result = markup do
      div do
        span
      end
    end
    assert result == "<div><span></span></div>"
  end

  test "attributes" do
    result = markup do
      div class: "test"
    end
    assert result == "<div class=\"test\"></div>"
  end   

  test "attributes with do" do
    result = markup do
      div class: "test" do
        span
      end
    end
    assert result == "<div class=\"test\"><span></span></div>"
  end   

  test "contents" do
    result = markup do
      div "test" 
    end
    assert result == "<div>test</div>"
  end

  test "creates an a" do
    result = markup do
      a href: "/"
    end
    assert result == ~s(<a href="/"></a>) 
  end


  test "includes content and attributes" do
    result = markup do
      div("Some content", [class: "my-class"])
    end
    assert result == ~s(<div class="my-class">Some content</div>)
  end

  test "nests" do
    result = markup do
      div do
        span "my span"
      end
    end
    assert result == "<div><span>my span</span></div>" 
  end

  test "nests 3 deep" do
    result = markup do
      div id: "one" do
        div id: "two" do
          div "Inner", id: "three"
        end
      end
    end
    assert result == ~s(<div id="one"><div id="two"><div id="three">Inner</div></div></div>)

  end

  test "two children" do
    result = markup do 
      div do
        div(id: "one")
        div(id: "two")
      end
    end
    assert result  == ~s(<div><div id="one"></div><div id="two"></div></div>)
  end

  test "self closing" do
    result = markup do
      input 
    end
    assert result == ~s(<input type="text"/>)
  end

  test "Example form" do
    expected = "<form method=\"post\" action=\"/model\" name=\"form\">" <>
               "<input type=\"text\" id=\"model[name]\" name=\"model_name\" value=\"my name\"/>" <>
               "<input type=\"hidden\" id=\"model[group_id]\" name=\"model_group_id\" value=\"42\"/>" <>
               "<input type=\"submit\" name=\"commit\" value=\"submit\"/>" <>
               "</form>"
    result = markup do
      form method: :post, action: "/model", name: "form" do
        input(type: :text, id: "model[name]", name: "model_name", value: "my name")
        input(type: :hidden, id: "model[group_id]", name: "model_group_id", value: "42")
        input(type: :submit, name: "commit", value: "submit")
      end
    end
    assert result == expected
  end

  test "default type for input" do
    result = markup do
      input(id: 1)
    end
    assert result  == ~s(<input id="1" type="text"/>)
  end

  test "supports id" do
    result = markup do
      div("#id") 
    end
    assert result == ~s(<div id="id"></div>)
  end

  test "support single class" do
    result = markup do
      div(".cls") 
    end
    assert result == ~s(<div class="cls"></div>)
  end

  test "support douple class and id" do
    result = markup do
      div(".cls.two#ids") 
    end
    assert result == ~s(<div class=\"cls two\" id=\"ids\"></div>)
  end

  test "support class and id attributes" do
    result = markup do
      div class: "cls two", id: "ids"
    end
    assert result == ~s(<div class=\"cls two\" id=\"ids\"></div>)
  end

  test "support .class and content and attribute" do
    result = markup do
      div ".cls content", for: "text"
    end
    assert result == ~s(<div class="cls" for="text">content</div>)
  end

  test "support string interpolation" do
    result = markup do
      var = "test"
      div ".#{var} content"
    end
    assert result == ~s(<div class="test">content</div>)
  end

  test "li, label, and input" do
    expected = "<li class=\"string input optional stringish\" id=\"contact_first_name_input\">" <> 
    "<label class=\"label\" for=\"contact_first_name\">first_name</label><input type=\"text\" " <> 
    "maxlength=\"255\" id=\"contact_first_name\" name=\"contact[first_name]\" value=\"\"/></li>"
    result = markup do
      model_name = "contact"
      field_name = "first_name"
      ext_name = "#{model_name}_#{field_name}"

      li( class: "string input optional stringish", id: "#{ext_name}_input") do
        label(".label #{field_name}", for: ext_name)
        input(type: :text, maxlength: "255", id: ext_name, name: "#{model_name}[#{field_name}]", value: "") 
      end
    end
    assert result == expected
  end

end