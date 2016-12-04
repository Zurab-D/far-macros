-----------------------------------------------------------------------------
-- raVen's smartpad 20161204-01
-----------------------------------------------------------------------------
Macro {
 area = "Editor Viewer Shell"; key="AltQ"; flags=""; action = function()
  if(
   editor.Editor(
    'd:' .. os.getenv("HOMEPATH") .. '\\docs\\smartpad\\smartpad.text', --filename
    nil, -- title
    nil, -- X1
    nil, -- Y1
    nil, -- X2
    nil, -- Y2
    {
     EF_NONMODAL = 1,
     EF_DISABLEHISTORY = 1,
     EF_IMMEDIATERETURN = 1,
     EF_OPENMODE_USEEXISTING = 1
    }, -- Flags
    nil, -- StartLine
    nil, -- StartChar
    65001 -- CodePage
   )
  ) then
   local ei = editor.GetInfo();
   local res = editor.SetPosition(
    ei.EditorID,
    ei.TotalLines,
    1,
    nil,
    nil,
    nil,
    nil
   );
   if(not res) then
    editor.Quit(ei.EditorID);
    return;
   end;
   local line_num = ei.TotalLines;
   while true do
    local line = editor.GetString(ei.EditorID, line_num).StringText;
    line_num = line_num - 1;
    local line_begin = '—————————————< '
    if(line:len() > 0) then
     if(not line:match(line_begin)) then
      for last_line = ei.TotalLines - 1, ei.TotalLines do
       if(editor.GetString(ei.EditorID, last_line).StringText:len() > 0) then
        Keys("End");
        editor.InsertString(ei.EditorID);
       end;
      end;
      editor.InsertText(
       ei.EditorID,
       os.date(line_begin .. '%a %Y/%m/%d %X >——————————————————————————\n')
      );
     end;
     break;
    end;
   end;
   Plugin.SyncCall('D2F36B62-A470-418D-83A3-ED7A3710E5B5', 11);
   editor.SaveFile(ei.EditorID, nil, nil, nil);
--   editor.Redraw(ei.EditorID);
  end;
 end;
};
