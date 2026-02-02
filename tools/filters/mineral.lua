-- Pandoc Lua filter to render mineral YAML front matter
-- into a proper section with properties and optional image.

local stringify = pandoc.utils.stringify

local function nonempty(meta_val)
  if not meta_val then return nil end
  local s = stringify(meta_val)
  if s == nil or s == '' then return nil end
  return s
end

function Pandoc(doc)
  local m = doc.meta or {}
  -- Only act on mineral pages (layout: mineral)
  if stringify(m.layout) ~= 'mineral' then
    return doc
  end

  local blocks = {}

  -- Page break before each mineral page
  table.insert(blocks, pandoc.RawBlock('typst', '#pagebreak()'))

  -- Title from name (fallback to id)
  local title = nonempty(m.name) or nonempty(m.id) or 'Mineral'
  table.insert(blocks, pandoc.Header(1, title))

  -- Properties as a definition list
  local props = {}
  local function add_prop(label, key)
    local val = nonempty(m[key])
    if val then
      table.insert(props, { { pandoc.Str(label) }, { pandoc.Plain({ pandoc.Str(val) }) } })
    end
  end

  add_prop('Formula', 'formula')
  add_prop('Class', 'mineral_class')
  add_prop('Group', 'group')
  add_prop('Crystal system', 'crystal_system')
  add_prop('Hardness (Mohs)', 'hardness_mohs')
  add_prop('Color', 'color')
  add_prop('Luster', 'luster')
  add_prop('Locality', 'locality')
  add_prop('Collected', 'collection_date')

  if #props > 0 then
    table.insert(blocks, pandoc.DefinitionList(props))
  end

  -- Optional primary image: check flat images[] first, then varieties[1].images[]
  local id = nonempty(m.id)
  local imgname = nil

  if m.images and m.images[1] then
    imgname = stringify(m.images[1])
  elseif m.varieties and m.varieties[1] and m.varieties[1].images and m.varieties[1].images[1] then
    imgname = stringify(m.varieties[1].images[1])
  end

  if id and imgname and imgname ~= '' then
    local path = 'images/' .. id .. '/' .. imgname
    table.insert(blocks, pandoc.Para({ pandoc.Image({}, path, '') }))
  end

  -- Separator before body content
  table.insert(blocks, pandoc.HorizontalRule())

  -- Append original content blocks
  for _, b in ipairs(doc.blocks) do
    table.insert(blocks, b)
  end

  return pandoc.Pandoc(blocks, m)
end

