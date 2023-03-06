require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Items"
  end

  test "should create item" do
    visit items_url
    click_on "New item"

    fill_in "Content", with: @item.content
    check "Cw" if @item.cw
    check "Deleted" if @item.deleted
    fill_in "Flow", with: @item.flow
    fill_in "Item", with: @item.item_id
    fill_in "Item type", with: @item.item_type
    fill_in "Meta", with: @item.meta
    check "Nsfw" if @item.nsfw
    fill_in "Uuid", with: @item.uuid
    fill_in "Version", with: @item.version
    click_on "Create Item"

    assert_text "Item was successfully created"
    click_on "Back"
  end

  test "should update Item" do
    visit item_url(@item)
    click_on "Edit this item", match: :first

    fill_in "Content", with: @item.content
    check "Cw" if @item.cw
    check "Deleted" if @item.deleted
    fill_in "Flow", with: @item.flow
    fill_in "Item", with: @item.item_id
    fill_in "Item type", with: @item.item_type
    fill_in "Meta", with: @item.meta
    check "Nsfw" if @item.nsfw
    fill_in "Uuid", with: @item.uuid
    fill_in "Version", with: @item.version
    click_on "Update Item"

    assert_text "Item was successfully updated"
    click_on "Back"
  end

  test "should destroy Item" do
    visit item_url(@item)
    click_on "Destroy this item", match: :first

    assert_text "Item was successfully destroyed"
  end
end
