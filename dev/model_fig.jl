using Luxor
using MathTeXEngine

begin
    Drawing(300, 300, joinpath("dev","sir.png"))
    fontsize(24)
    background("white")

    origin()
    y_line = 150/2
# SIR
    Luxor.text(L"S_{a,t}",Point(-100,y_line), halign = :center)
    Luxor.text(L"S_{b,t}",Point(-100,-y_line), halign = :center)
    Luxor.text(L"I_{a,t}",Point(0,y_line), halign = :center)
    Luxor.text(L"I_{b,t}",Point(0,-y_line), halign = :center)

    Luxor.text(L"R_{a,t}",Point(100,y_line), halign = :center)
    Luxor.text(L"R_{b,t}",Point(100,-y_line), halign = :center)

    sethue("black")
    Luxor.box(-100,-y_line, 50, 50, :stroke)

finish()
end
