class MotifsController < ApplicationController
  def index
    redirect_to root_path  unless ['HUMAN', 'MOUSE'].include?(species)
    redirect_to root_path  unless ['mono', 'di'].include?(arity)
    @models = Motif.each_in_file(Rails.root.join("public/final_bundle/#{species}/#{arity}/final_collection.tsv"))
    @models = MotifDecorator.decorate_collection(@models)
  end

protected
  def species; params[:species].upcase;end  
  def arity; params[:arity].downcase; end
  def csv_filename; "#{species}_#{arity}_motifs.tsv"; end
  def caption
    (((arity == 'di') ? 'Dinucleotide ' : '') + "PWMs for #{species}<br/> transcription factors").html_safe
  end
  helper_method :species, :arity, :csv_filename
end
