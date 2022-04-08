function plot2Pdf( filename, width, height )

set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 width height]);
set(gcf,'Units','centimeters','PaperSize',[width height]);
set(gcf,'Renderer','Painters');
saveas(gcf, filename, 'pdf')

end