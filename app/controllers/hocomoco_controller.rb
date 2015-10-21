class HocomocoController < ApplicationController
  def searchPost
    match = params[:kind].match(/(?<species>human|mouse);(?<arity>mono|di)/i)
    species = 'human'
    arity = 'mono'
    if match
      species = match[:species]
      arity = match[:arity]
    end

    hsh = [:family_id, :query].map{|el| [el, params[el]] }.reject{|k,v| v.nil? }.to_h
    redirect_to search_path(hsh.merge(species: species, arity: arity))
  end

  def search
    species = params[:species]
    arity = params[:arity]
    redirect_to root_path  unless species && arity
    models = Motif.in_bundle(species: species, arity: arity)

    if params[:family_id] && !params[:family_id].blank?
      models = models.select{|motif|
        motif.is_a_subfamily_member?(params[:family_id])
      }
    end

    if params[:query] && !params[:query].blank?
      models = models.select{|motif|
        motif.match_query?(params[:query])
      }
    end

    models = MotifDecorator.decorate_collection(models)

    render 'motifs/index', locals: {
      models: models,
      species: species,
      arity: arity,
      csv_filename: "#{species}_#{arity}_motifs.tsv",
      family_id: params[:family_id],
      disable_default_filters: true
    }
  end

  def home; end
  def downloads; end
  def tree
    render layout: 'bare'
  end
end
