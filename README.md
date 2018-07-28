# Curveds-Unity-Shaders

Cubed's Unity Shaders  
<https://github.com/cubedparadox/Cubeds-Unity-Shaders>  
Copyright (c) 2017 Nicholas Benge  
を改変し、個人的にあんまり使わない処理を消すor#defineでON/OFF&リファクタして軽くするついでに以下を導入したShader
* 影境界を操る程度の能力
* リムライト(端の光)
* ハイライト(反射光)
* ファー(もふもふ)
* Stencil(窓枠)




ファーは下のやつなど参考に実装
* ファーシェーダを移植してみた(ファーシェーダー作成時に参考)
<https://qiita.com/edo_m18/items/75db04f117355adcadbb>

Stencilは以下を参考、Windowについてはほぼコピペ 
* HoloLens Playground
<http://tips.hecomi.com/entry/2017/02/18/190949>
<https://github.com/hecomi/HoloLensPlayground>
Copyright (c) 2017 hecomi