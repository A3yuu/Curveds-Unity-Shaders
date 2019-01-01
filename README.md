# Curveds-Unity-Shaders

Cubed's Unity Shaders  
<https://github.com/cubedparadox/Cubeds-Unity-Shaders>  
Copyright (c) 2017 Nicholas Benge  
を改変し、個人的にあんまり使わない処理を消すor#ifdefでON/OFF&リファクタして軽くなったらいいなのついでに以下を導入したShader
* 影境界ぼかし
* リムライト(端の光)
* ハイライト(反射光)
* ファー(もふもふ)
* Stencil(窓枠)
以下2019年1/1追加分
* Tessellation(メッシュ細かく)
* 自アバター用実装その1~4(Additional***)
* 自アバター用実装髪用(Hair)

IndirectLightingあたりの実装とか見るととってもなごってるはず。  
代表的な削った機能としては、アウトライン(つらい)、Trans/Fade(Zバッファでやるやつって半透明無理だよね･･･)

ファーは下のやつなど参考に実装
* ファーシェーダを移植してみた(ファーシェーダー作成時に参考)  
<https://qiita.com/edo_m18/items/75db04f117355adcadbb>

Stencilは以下などを参考、Windowについてはほぼコピペ 
* HoloLens Playground  
<http://tips.hecomi.com/entry/2017/02/18/190949>  
<https://github.com/hecomi/HoloLensPlayground>  
Copyright (c) 2017 hecomi

コード参考にするなら、一つ前のが見やすいかも？