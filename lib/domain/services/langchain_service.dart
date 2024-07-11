import 'package:langchain/langchain.dart';
import 'package:todo_app/core/openai_key.dart';
import 'package:todo_app/core/pinecone_key.dart';
import 'package:langchain_pinecone/langchain_pinecone.dart';
import 'package:langchain_openai/langchain_openai.dart';


class LangchainService {

  final openaiApiKey = OPENAI_KEY;
  final pineconeApiKey = PINECONE_KEY;
  late final OpenAIEmbeddings openaiEmbeddings;

  late final Pinecone vectorStore;
  
  LangchainService() {

    openaiEmbeddings = OpenAIEmbeddings(apiKey: openaiApiKey);

    vectorStore = Pinecone(
      apiKey: pineconeApiKey, 
      indexName: PINECONE_INDEXNAME, 
      embeddings: openaiEmbeddings
      );
  }

  Future<bool> deleteVector(String id) async {
    await vectorStore.delete(ids: [id]);
    
    return true;
  }

  Future<bool> addVector(
    List<double> embedding, 
    String id, 
    String name, 
    String userEmail ) async {
    
    List<String> ids = await vectorStore.addVectors(
      vectors: [embedding], 
      documents: [Document(
        id: id,
        pageContent: name,
        metadata: {
          'user': userEmail
        })
      ]
    );

    if(ids.isEmpty) {
      return false;
    }
    
    return ids[0] == id;
  }

  Future<List<double>> getEmbeddings(String json) async {
    List<double> embeddings = await openaiEmbeddings.embedQuery(json);
  
    return embeddings;
  }

  Future<List<String>> getSimilarDocumentIds(String query, String userEmail) async {
    List<String> ids = [];

    List<Document> documents = await vectorStore.similaritySearch(
      query: query,
      config: PineconeSimilaritySearch(
        k: 4,
        filter: { 'user': userEmail }
      ));

    for (var document in documents) {
      if(document.id == null) continue;

      ids.add(document.id!);
    }

    return ids;
  }

}