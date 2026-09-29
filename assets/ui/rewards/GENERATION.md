# Reward medallion atlas

Generated 29 September 2026 using built-in imagegen. No CLI fallback.
Final project asset: `medallions.png` (1536×1024 RGBA, 3×2 cells).

## Generation prompt

Use case: stylized-concept. Asset type: production mobile game UI sprite atlas, one square transparent PNG, 3 columns by 2 rows of six separate richly illustrated button medallions. Pixel Heist night museum aesthetic: dimensional antique brass rims, warm gold highlights, deep cobalt navy and jewel turquoise enamel, polished copper details, stylized animated-film painterly rendering with clean outlines. Each of six equal square cells contains one centered complete circular medallion, generously padded so sprites never touch cell edges. Top row left: open turquoise treasure chest overflowing with bright gold coins, daily gift reward. Top middle: ornate sapphire chest crowned by one big golden five-point star, star reward. Top right: burgundy museum strongbox with a tiny ornate gold framed painting behind it, milestone reward. Bottom left: turquoise cinema clapperboard with ivory triangular play symbol and a small stack of gold coins, rewarded video. Bottom middle: purple enamel shield with a brass video screen symbol crossed out by a coral diagonal slash, remove interstitial ads. Bottom right: luxurious purple gift box with a large golden ribbon and coins, special offer. All six have identical brass circular outer rim and short curved enamel pedestal with an EMPTY caption plaque at the bottom. Large legible silhouette and sculptural relief at phone size. No text, no letters, no numbers, no characters, no humans, no background, real alpha transparency around each medallion. Uniform orthographic front three-quarter view, no perspective grid. This is a single coherent sprite sheet, not a screenshot.

## Alpha correction prompt

Remove the entire golden/brown background outside the six separate brass medallion silhouettes. Output MUST have real alpha transparency, not a flat background or checkerboard painting. Keep every sprite, its circular brass rim, its internal colors, contents and empty caption plaque identical. Put them in exactly 3 equal columns and 2 equal rows, one centered sprite per equal square cell. Reduce each medallion slightly within its cell to leave 24 pixels of transparent padding on all four sides. Retain the same landscape 3:2 atlas format. No text. Only the isolated medallion sprites, everything around them fully transparent.

Alpha verified from the PNG: outer corners are zero alpha, interior art is opaque. The runtime uses atlas regions without recoloring or redrawing the sprites.
