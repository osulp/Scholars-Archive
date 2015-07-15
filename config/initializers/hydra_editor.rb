HydraEditor.models = ["GenericFile"]
HydraEditor::Fields::Generator.factory = ScholarsArchive::Fields::InputFactory.new(
  HydraEditor::Fields::Factory,
  DecoratorList.new(HasHintOption, HasURIInputType)
)
