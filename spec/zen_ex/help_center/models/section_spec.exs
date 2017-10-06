defmodule ZenEx.HelpCenter.Model.SectionSpec do
  use ESpec

  alias ZenEx.HelpCenter.Entity.{Category, Section}
  alias ZenEx.HelpCenter.Model

  let :category do
    struct(Category, %{id: 112233, name: "My printer is on fire!", locale: "en-us"})
  end

  let :json_sections do
    ~s({"count":2,"sections":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","category_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","category_id":112233}]})
  end
  let :sections do
    [struct(Section, %{id: 35436, name: "Help I need somebody!", locale: "en-us", category_id: category().id}),
     struct(Section, %{id: 20057623, name: "Not just anybody!", locale: "en-us", category_id: category().id})]
  end

  let :json_section, do: ~s({"section":{"id":35436,"name":"My printer is on fire!","locale":"en-us","category_id":112233}})
  let :section, do: struct(Section, %{id: 35436, name: "My printer is on fire!", locale: "en-us", category_id: category().id})

  let :response_section, do: %HTTPotion.Response{status_code: 200, body: json_section()}
  let :response_sections, do: %HTTPotion.Response{status_code: 200, body: json_sections()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_sections() end)
    it do: expect Model.Section.list("en-us") |> to(be_struct ZenEx.Collection)
    it do: expect Model.Section.list("en-us").entities |> to(eq sections())
    it do: expect Model.Section.list("en-us", category().id).entities |> to(eq sections())
  end

  describe "show" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_section() end)
    it do: expect Model.Section.show("en-us", section().id) |> to(eq section())
  end

  describe "create" do
    before do: allow HTTPotion |> to(accept :post, fn(_, _) -> response_section() end)
    it do: expect Model.Section.create(section()) |> to(be_struct Section)
  end

  describe "update" do
    before do: allow HTTPotion |> to(accept :put, fn(_, _) -> response_section() end)
    it do: expect Model.Section.update(section()) |> to(be_struct Section)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_204() end)
      it do: expect Model.Section.destroy(section().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_404() end)
      it do: expect Model.Section.destroy(section().id) |> to(eq :error)
    end
  end
end
