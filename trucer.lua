-----------------------------------------------------------------------------
-- raVen's trucer 20160913
-- trim spaces at end of lines
-----------------------------------------------------------------------------

-- mask:
local files = '*.*|*.exe,*.com,*.dll,*.msg,*.pkt,*.sqd,*.sqi,*.jdt,*.jdx,*.jhr,*.jlr,*.tbb,*.diff,*.ml';

-- trim trail spaces by pressing 'end':
local trim_by_end = true;

-- trim trail spaces at file read:
local trim_at_read = false;

-- trim trail spaces at file save:
local trim_at_save = true;

-- limit lines of file to trim trail spaces:
local trim_lines_limit = 222222;

-- trunc empty lines at end of file:
local trunc_empty_lines = true;

-- macro:
Macro {
 area = 'Editor';
 description = 'trim spaces at eol by "end" key combinations';
 filemask = files;
 key = '/([LR]Alt|Shift)?End/';
 action = function()
  if trim_by_end then
   local str, eol = editor.GetString(nil, nil, 3);
   local trm = mf.trim(str, 2);
   if str ~= trm then
    editor.SetString(nil, nil, trm, eol);
   end;
  end;
  Keys('AKey');
 end;
}

-- event:
Event {
 group = 'EditorEvent';
 description = 'trim spaces at eol by save or load file';
 filemask = files;
 action = function(eid, event)
  if not(
   (event == far.Flags.EE_READ) and trim_at_read or
   (event == far.Flags.EE_SAVE) and trim_at_save
  ) then
   return;
  end;
  local sav_info = editor.GetInfo(eid);
  if(sav_info.TotalLines >= trim_lines_limit) then
   return;
  end;
  local ctime = os.time();
  local cnt = 0;
  for cline = 1, sav_info.TotalLines, 1 do
   local str, eol = editor.GetString(eid, cline, 3);
   local trm = mf.trim(str, 2);
--   string.match(str,'^()%s*$') and '' or string.match(str,'^(.*%S)');
   if str ~= trm then
    editor.SetString(eid, cline, trm, eol);
    cnt = cnt + 1;
   end;
   local ntime = os.time();
   if(ntime > ctime) then
    local s = string.format(
     ' truced %d lines %05.02f%% total ',
     cnt,
     cline / sav_info.TotalLines * 100
    );
    far.Text(0, 0, 15, s);
    far.Text();
    ctime = ntime;
    local key = mf.waitkey(1);
    if(key == 'Esc') then
     msgbox('trucer', 'aborted by user');
     break
    end;
   end;
  end;
  if trunc_empty_lines then
   for i = sav_info.TotalLines, 0, -1 do
    if(
     (editor.GetString(eid, i, 2) == '') and
     (editor.GetString(eid, i - 1, 2) == '') and
     (i > 1)
    ) then
     editor.DeleteString(eid);
    else
     break;
    end;
   end;
  end;
  editor.SetPosition(eid, sav_info);
  far.Text();
 end;
}
