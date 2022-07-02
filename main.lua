require("wx")
local frame=wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxLua 8-Puzzle")

size=3

function grid_set()
  for row=1,size do
    for col=1,size do
      local text=table_grid[row][col]
      if text==0 then text="" end
      buttons[row][col]:SetLabel(tostring(text))
    end
  end
end

function table_grid_sorted()
  local table_grid = {}

  for row_id = 1,size do
  
    local row = {}
    for column_id = 1,size do
      local number
      
      -- sorted number
      number = column_id + (row_id-1)*size
      if row_id==size and column_id==size then
        number = 0
      end
      
      table.insert(row, number)
    end
    table.insert(table_grid, row)
  
  end
  
  return table_grid
end


function table_grid_swap(grid,row1,column1,row2,column2)
  grid[row1][column1], grid[row2][column2] = grid[row2][column2], grid[row1][column1]
end

function OnButton(button,row_id, column_id)

    function swap(row_id_2, column_id_2)
      table_grid_swap(table_grid,row_id,column_id,row_id_2,column_id_2)
      grid_set()
    end
    
    -- left
    if column_id > 1 and table_grid[row_id][column_id - 1] == 0 then
      swap(row_id, column_id - 1)
    end
    
    -- right
    if column_id < size and table_grid[row_id][column_id + 1] == 0 then
      swap(row_id, column_id + 1)
    end
    
    -- up
    if row_id > 1 and table_grid[row_id - 1][column_id] == 0 then
      swap(row_id - 1, column_id)
    end
    
    -- down
    if row_id < size and table_grid[row_id + 1][column_id] == 0 then
      swap(row_id + 1, column_id)
    end
end

local grid=wx.wxGridSizer(size,size,0,0)
buttons={}
for row=1,size do
  local row_buttons={}
  for col=1,size do
    local button
    button=wx.wxButton(frame, wx.wxID_ANY, row..","..col , wx.wxPoint(0,0), wx.wxSize(100,100))
    button:SetCanFocus(false)
    
    local font = button:GetFont()
    font:SetPointSize(50)
    button:SetFont(font)
    
    button:Connect(wx.wxEVT_COMMAND_BUTTON_CLICKED, function() OnButton(button,row,col) end)
    table.insert(row_buttons,button)
    grid:Add(button, wx.wxID_ANY, wx.wxGROW + wx.wxALL)
  end
  table.insert(buttons,row_buttons)
end

frame:SetAutoLayout(true)
frame:SetSizer(grid)

grid:SetSizeHints(frame)
grid:Fit(frame)

table_grid=table_grid_sorted()
grid_set()

frame:Show(true)
wx.wxGetApp():MainLoop()